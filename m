From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] pass through support in fc transport: via bsg (block SG)
Date: Thu, 11 Sep 2008 09:44:23 -0400
Message-ID: <48C920B7.1020704@emulex.com>
References: <1283B1A7-A1A2-465A-A9E4-07A778BC3FE8@qlogic.com> <423FD491-FCA2-4CBF-8411-B08E90243236@qlogic.com> <7773BCE2-99A3-467D-B7AF-C182F2773A9C@qlogic.com> <48AF3547.4040703@emulex.com> <4627F04F-2980-4C9B-AED7-891452BA84E2@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:32933 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYIKNou (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2008 09:44:50 -0400
In-Reply-To: <4627F04F-2980-4C9B-AED7-891452BA84E2@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: Robert W Love <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

Seokmann,

I apologize for the late review. I'm going over it now. (PS: ping me 
next time if you want to makre sure I've looked at it). I should have 
comments within the day.

Seokmann Ju wrote:
> I actually had missed the point at that time and now I'm getting it as
> I read one more time.
> So, in this case, how to identify whether the request is ELS or CT if
> the application issues the request without the frame header?

Whether it's ELS or CT should be part of the metadata of the request (a 
flag, a request type opcode, or similar).  There should be no reason for 
a frame header.

-- james s

