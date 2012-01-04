From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_tcp: bound max_r2t in iscsi_sw_tcp_conn_set_param()
Date: Wed, 04 Jan 2012 01:16:57 -0600
Message-ID: <4F03FCE9.1090603@cs.wisc.edu>
References: <1325368867-13696-1-git-send-email-xi.wang@gmail.com> <4F015753.1010106@cs.wisc.edu> <2EB25344-4C9E-4D3C-8406-5A4D015CB364@gmail.com> <260F336C-1C68-4DDE-9FFB-094F7AEFB3C8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58830 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab2ADHJO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 02:09:14 -0500
In-Reply-To: <260F336C-1C68-4DDE-9FFB-094F7AEFB3C8@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xi Wang <xi.wang@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On 01/04/2012 12:36 AM, Xi Wang wrote:
> On Jan 2, 2012, at 9:18 AM, Xi Wang wrote:
>> On Jan 2, 2012, at 2:05 AM, Mike Christie wrote:
>>> What about the attached patch? It also fixes cxgb*i.
>>> <0001-libiscsi_tcp-fix-max_r2t-manipulation.patch>
>>
>> Looks good to me.  Thanks!
> 
> BTW, should max_r2t be in the range 1..65535 according to RFC 3720?

Yeah.

> Using ushort seems to limit the upper bound to 32768, though probably
> no one wants to set it to such a large value.

I thought short was 32767 and ushort was 65535. Is a short like long
where it is different on different archs?
