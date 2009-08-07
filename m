From: Noriyuki Fujii <n-fujii@np.css.fujitsu.com>
Subject: [PATCH] PCI legacy I/O port free driver - Making MegaRAID SAS driver
Date: Fri, 07 Aug 2009 14:24:22 +0900
Message-ID: <4A7BBA86.2040504@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050905040607050207080001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48012 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZHGFYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 01:24:12 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n775OB7T018660
	for <linux-scsi@vger.kernel.org> (envelope-from n-fujii@np.css.fujitsu.com);
	Fri, 7 Aug 2009 14:24:11 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 243E045DE56
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2009 14:24:11 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id D421345DE51
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2009 14:24:10 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 995BA1DB8044
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2009 14:24:10 +0900 (JST)
Received: from m002.s.css.fujitsu.com (m002.s.css.fujitsu.com [10.23.4.32])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 2546F1DB8037
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2009 14:24:10 +0900 (JST)
Received: from m002.css.fujitsu.com (m002 [127.0.0.1])
	by m002.s.css.fujitsu.com (Postfix) with ESMTP id F1BC92DFE49
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2009 14:24:09 +0900 (JST)
Received: from [127.0.0.1] (dhcp111-190.sky.yk.fujitsu.co.jp [10.33.111.190])
	by m002.s.css.fujitsu.com (Postfix) with ESMTP id C52C82DFE48
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2009 14:24:09 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050905040607050207080001
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

I made a patch for MegaRAID sas driver to make PCI legacy I/O port free.

The way to make PCI legacy I/O port free is the same as Fusion-MPT
driver's and it has been merged into 2.6.30.4.

As a result of the above, the driver can handle its device even when
there are a huge number of PCI devices being used on the system and no
I/O port region assigned to the device.

I'm not in the linux-scsi mailing list.
Please reply to the following address.

 E-Mail: n-fujii@np.css.fujitsu.com

Thanks,
Noriyuki Fujii


--------------050905040607050207080001
Content-Type: text/plain;
 name="linux-2.6-scsi-megaraid-sas-make-legacy-i-o-port-free.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="linux-2.6-scsi-megaraid-sas-make-legacy-i-o-port-free.patch"

LS0tIG1lZ2FyYWlkX3Nhc09yZy5jCTIwMDktMDctMDIgMTY6MzE6MTcuMDAwMDAwMDAwICsw
OTAwCisrKyBtZWdhcmFpZF9zYXNNb2QuYwkyMDA5LTA4LTA2IDExOjI0OjQyLjAwMDAwMDAw
MCArMDkwMApAQCAtMjU3Myw3ICsyNTczLDkgQEAgc3RhdGljIGludCBtZWdhc2FzX2luaXRf
bWZpKHN0cnVjdCBtZWdhcwogCQlpbnN0YW5jZS0+YmFzZV9hZGRyID0gcGNpX3Jlc291cmNl
X3N0YXJ0KGluc3RhbmNlLT5wZGV2LCAwKTsKIAl9CiAKLQlpZiAocGNpX3JlcXVlc3RfcmVn
aW9ucyhpbnN0YW5jZS0+cGRldiwgIm1lZ2FzYXM6IExTSSIpKSB7CisgICAgICAgIGlmIChw
Y2lfcmVxdWVzdF9zZWxlY3RlZF9yZWdpb25zKGluc3RhbmNlLT5wZGV2LAorCQkJCQkgcGNp
X3NlbGVjdF9iYXJzKGluc3RhbmNlLT5wZGV2LCBJT1JFU09VUkNFX01FTSksCisJCQkJCSAi
bWVnYXNhczogTFNJIikpIHsKIAkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IElPIG1l
bW9yeSByZWdpb24gYnVzeSFcbiIpOwogCQlyZXR1cm4gLUVCVVNZOwogCX0KQEAgLTI3MTks
NyArMjcyMSw4IEBAIHN0YXRpYyBpbnQgbWVnYXNhc19pbml0X21maShzdHJ1Y3QgbWVnYXMK
IAlpb3VubWFwKGluc3RhbmNlLT5yZWdfc2V0KTsKIAogICAgICAgZmFpbF9pb3JlbWFwOgot
CXBjaV9yZWxlYXNlX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYpOworICAgICAgICBwY2lfcmVs
ZWFzZV9zZWxlY3RlZF9yZWdpb25zKGluc3RhbmNlLT5wZGV2LAorCQkJCSAgICAgcGNpX3Nl
bGVjdF9iYXJzKGluc3RhbmNlLT5wZGV2LCBJT1JFU09VUkNFX01FTSkpOwogCiAJcmV0dXJu
IC1FSU5WQUw7CiB9CkBAIC0yNzM5LDcgKzI3NDIsOCBAQCBzdGF0aWMgdm9pZCBtZWdhc2Fz
X3JlbGVhc2VfbWZpKHN0cnVjdCBtCiAKIAlpb3VubWFwKGluc3RhbmNlLT5yZWdfc2V0KTsK
IAotCXBjaV9yZWxlYXNlX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYpOworICAgICAgICBwY2lf
cmVsZWFzZV9zZWxlY3RlZF9yZWdpb25zKGluc3RhbmNlLT5wZGV2LAorCQkJCSAgICAgcGNp
X3NlbGVjdF9iYXJzKGluc3RhbmNlLT5wZGV2LCBJT1JFU09VUkNFX01FTSkpOwogfQogCiAv
KioKQEAgLTMwNDksNyArMzA1Myw3IEBAIG1lZ2FzYXNfcHJvYmVfb25lKHN0cnVjdCBwY2lf
ZGV2ICpwZGV2LCAKIAkvKgogCSAqIFBDSSBwcmVwcGluZzogZW5hYmxlIGRldmljZSBzZXQg
YnVzIG1hc3RlcmluZyBhbmQgZG1hIG1hc2sKIAkgKi8KLQlydmFsID0gcGNpX2VuYWJsZV9k
ZXZpY2UocGRldik7CisgICAgICAgIHJ2YWwgPSBwY2lfZW5hYmxlX2RldmljZV9tZW0ocGRl
dik7CiAKIAlpZiAocnZhbCkgewogCQlyZXR1cm4gcnZhbDsKQEAgLTMzNDMsNyArMzM0Nyw3
IEBAIG1lZ2FzYXNfcmVzdW1lKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQogCS8qCiAJICogUENJ
IHByZXBwaW5nOiBlbmFibGUgZGV2aWNlIHNldCBidXMgbWFzdGVyaW5nIGFuZCBkbWEgbWFz
awogCSAqLwotCXJ2YWwgPSBwY2lfZW5hYmxlX2RldmljZShwZGV2KTsKKyAgICAgICAgcnZh
bCA9IHBjaV9lbmFibGVfZGV2aWNlX21lbShwZGV2KTsKIAogCWlmIChydmFsKSB7CiAJCXBy
aW50ayhLRVJOX0lORk8gIm1lZ2FzYXM6IEVuYWJsZSBkZXZpY2UgZmFpbGVkXG4iKTsK
--------------050905040607050207080001--

