From: Doug Ledford <dledford@redhat.com>
Subject: Re: Autosense requirement
Date: Mon, 29 Jul 2002 17:58:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729175827.N20905@redhat.com>
References: <3D453CE8.5A15FCD6@splentec.com> <3D457FF3.C7A02C57@torque.net> <20020729155518.B20905@redhat.com> <20020729145326.A23512@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aladin.rdu.redhat.com (aladin.rdu.redhat.com [172.16.57.71])
	by lacrosse.corp.redhat.com (8.11.6/8.9.3) with ESMTP id g6TLwRm01016
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 17:58:27 -0400
Received: (from dledford@localhost)
	by aladin.rdu.redhat.com (8.11.6/8.11.6) id g6TLwRs21048
	for linux-scsi@vger.kernel.org; Mon, 29 Jul 2002 17:58:27 -0400
Content-Disposition: inline
In-Reply-To: <20020729145326.A23512@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Jul 29, 2002 at 02:53:26PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Jul 29, 2002 at 02:53:26PM -0700, Mike Anderson wrote:
> Doug,
> 	I assume from your message that you are removing the call from
> 	scsi_unjam_host to do request sense (which is good). 
> 	
> 	Does this imply that your reworking all of the eh handling in
> 	scsi_error.c?

Yeah, I had some stuff I want to do there.  However, I'm currently working 
on other things right now.  I was saving this for later :-/

> 	I was doing some rework in this area, but it sounds like it might
> 	be counter to your work.

Go ahead.  I'm not into that section yet.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
