From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: Autosense requirement
Date: Mon, 29 Jul 2002 15:28:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3679966B84813344B908D418BA3F6A4AA83FAD@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

Does this also mean low level driver will be responsible for taking action on the basis of the sense data coming back from the device ?

Ravi
-----Original Message-----
From: Mike Anderson [mailto:andmike@us.ibm.com]
Sent: Monday, July 29, 2002 2:53 PM
To: Doug Ledford
Cc: linux-scsi@vger.kernel.org
Subject: Re: Autosense requirement


Doug Ledford [dledford@redhat.com] wrote:
> It will be mandatory for the LLDD to do autosense.  All remnants of code 
> to perform a follow up request sense operation *will* dissappear from the 
> mid layer.  OTOH, the sense command and sense buffer will be pre-set for 
> each device so at least the LLDD won't have to build their own command any 
> longer, they can just change the command pointer from the original command 
> to the sense command and the data buffer to the sense buffer and reissue 
> the request.

Doug,
	I assume from your message that you are removing the call from
	scsi_unjam_host to do request sense (which is good). 
	
	Does this imply that your reworking all of the eh handling in
	scsi_error.c?

	I was doing some rework in this area, but it sounds like it might
	be counter to your work.

-Mike
-- 
Michael Anderson
andmike@us.ibm.com

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
