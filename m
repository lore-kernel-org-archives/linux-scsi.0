From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Autosense requirement
Date: Mon, 29 Jul 2002 15:10:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729151027.A2657@eng2.beaverton.ibm.com>
References: <3D453CE8.5A15FCD6@splentec.com> <3D457FF3.C7A02C57@torque.net> <20020729155518.B20905@redhat.com> <20020729145326.A23512@beaverton.ibm.com> <20020729175827.N20905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e21.nc.us.ibm.com (8.12.2/8.12.2) with ESMTP id g6TMAfRY142122
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 18:10:41 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.3) with ESMTP id g6TMAecI109364
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 16:10:40 -0600
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.10.0.Beta10/8.11.6) with ESMTP id g6TMAYe03064
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 15:10:34 -0700 (PDT)
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g6TMARj02763
	for linux-scsi@vger.kernel.org; Mon, 29 Jul 2002 15:10:27 -0700 (PDT)
In-Reply-To: <20020729175827.N20905@redhat.com>; from dledford@redhat.com on Mon, Jul 29, 2002 at 05:58:27PM -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Jul 29, 2002 at 05:58:27PM -0400, Doug Ledford wrote:
> On Mon, Jul 29, 2002 at 02:53:26PM -0700, Mike Anderson wrote:
> > Doug,
> > 	I assume from your message that you are removing the call from
> > 	scsi_unjam_host to do request sense (which is good). 
> > 	
> > 	Does this imply that your reworking all of the eh handling in
> > 	scsi_error.c?
> 
> Yeah, I had some stuff I want to do there.  However, I'm currently working 
> on other things right now.  I was saving this for later :-/
> 
> > 	I was doing some rework in this area, but it sounds like it might
> > 	be counter to your work.
> 
> Go ahead.  I'm not into that section yet.

Doug -

I'm also doing some scsi changes - scsi_scan.c cleanup, and
multi-path IO support.

Are you doing work that affects scsi_scan.c?

Do you have a tree or such that we can sync up with?

Any moderate changes to scsi will likely affect the multi-path changes.

-- Patrick Mansfield
