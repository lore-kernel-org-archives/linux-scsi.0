From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Autosense requirement
Date: Mon, 29 Jul 2002 14:53:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729145326.A23512@beaverton.ibm.com>
References: <3D453CE8.5A15FCD6@splentec.com> <3D457FF3.C7A02C57@torque.net> <20020729155518.B20905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020729155518.B20905@redhat.com>; from dledford@redhat.com on Mon, Jul 29, 2002 at 03:55:18PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

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

