From: "Jansen, Frank" <fjansen@egenera.com>
Subject: RE: Number of devices that SCSI can support
Date: Wed, 9 Jan 2008 07:42:51 -0500
Message-ID: <216D6FA68B0F304DA93E95C5B786F2D126D7AA@bart.corp.egenera.com>
References: <404714.86520.qm@web43145.mail.sp1.yahoo.com> <20080109022233.GM16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from webaccess.egenera.com ([63.139.209.15]:54042 "EHLO
	webaccess.egenera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYAINBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 08:01:30 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Cc: linux-scsi@vger.kernel.org

You will want to check the BIOS settings on the Qlogic HBA, if you are running into a problem.  Also, there may be limitations that are inherent to the storage to which you are connecting.

Regards,

Frank


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org on behalf of Matthew Wilcox
Sent: Tue 1/8/2008 9:22 PM
To: Vinay Venkataraghavan
Cc: linux-scsi@vger.kernel.org
Subject: Re: Number of devices that SCSI can support
 
On Tue, Jan 08, 2008 at 04:55:46PM -0800, Vinay Venkataraghavan wrote:
> Is there a limit on the number of devices that SCSI supports. In other words, I have a QLogic HBA card, and I am connecting to a SAN which has 64 targets. 

I've personally had over five hundred LUNs.  You shouldn't be hitting a
limit here.

> I am running 2.6.9-42. 

That sounds like a Red Hat Enterprise kernel.  Perhaps you should
contact them for support?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

