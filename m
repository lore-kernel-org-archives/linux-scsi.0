From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: 2.6.8-rc3-mm2:  Debug: sleeping function called from invalid context at mm/mempool.c:197
Date: Mon, 9 Aug 2004 16:56:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD03A6@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C47E6C.811F4276"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:61003 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S267347AbUHJAAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 20:00:01 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Janet Morgan <janetmor@us.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C47E6C.811F4276
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Monday, August 09, 2004 6:42 AM, linux-kernel-owner@vger.kernel.org
wrote:=20
> I see the msg below while running on 2.6.8-rc3-mm2, but not
> on the plain
> rc3 tree;
> ditto for rc1-mm1 vs rc1, which is as far back as I've gone so far.
>

This allocation should be done with GFP_ATOMIC flags.  The attached=20
patch should apply cleanly to any recent kernel.

Regards,
Andrew Vasquez

------_=_NextPart_001_01C47E6C.811F4276
Content-Type: application/octet-stream;
	name="mpool_alloc.diff"
Content-Transfer-Encoding: base64
Content-Description: mpool_alloc.diff
Content-Disposition: attachment;
	filename="mpool_alloc.diff"

PT09PT0gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMgMS4zOSB2cyBlZGl0ZWQgPT09PT0K
LS0tIDEuMzkvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMJMjAwNC0wNy0xMiAwOTo1NDo0
OSAtMDc6MDAKKysrIGVkaXRlZC9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYwkyMDA0LTA4
LTA5IDE2OjQ4OjI5IC0wNzowMApAQCAtMzU5MCw3ICszNTkwLDcgQEAKIHsKIAlzcmJfdCAqc3A7
CiAKLQlzcCA9IG1lbXBvb2xfYWxsb2MoaGEtPnNyYl9tZW1wb29sLCBHRlBfS0VSTkVMKTsKKwlz
cCA9IG1lbXBvb2xfYWxsb2MoaGEtPnNyYl9tZW1wb29sLCBHRlBfQVRPTUlDKTsKIAlpZiAoc3Ap
CiAJCWF0b21pY19zZXQoJnNwLT5yZWZfY291bnQsIDEpOwogCXJldHVybiAoc3ApOwo=

------_=_NextPart_001_01C47E6C.811F4276--
