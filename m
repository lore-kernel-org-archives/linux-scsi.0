From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 20 Nov 2003 13:34:33 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120133433.A31298@infradead.org>
References: <200310231734.10263.krmurthy@cisco.com> <03111920183201.15831@naveenb-lnx.cisco.com> <20031119091717.A11499@beaverton.ibm.com> <03112019020601.16789@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:1035 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261780AbTKTNej (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 08:34:39 -0500
Content-Disposition: inline
In-Reply-To: <03112019020601.16789@naveenb-lnx.cisco.com>; from naveenb@cisco.com on Thu, Nov 20, 2003 at 07:02:06PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Thu, Nov 20, 2003 at 07:02:06PM +0530, Naveen Burmi wrote:
> Lun masking feature is provided by the linux-iscsi driver. In the linux-iscsi 
> driver configuration file user can specify the luns of a target that needs to 
> be activated upon the detection of that target.
> 
> > If you already have the LUN specified, why do you need to issue a REPORT
> > LUN command?
> 
> User has specified the LUNs that needs to be activated upon the detection of 
> a target. Once that target gets detected then to find out weather the LUNs 
> specified by the user are actually present, we need to issue REPORT LUN 
> command.
>  
> >
> > I don't know iSCSI specification details, but I would want to specify a
> > target, not a LUN, in a configuration file and have all LUNs on the target
> > be automatically configured.
> >
> 
> User might not want to configure all the LUNs of a target. 

I'm not sure I agree with that.  Users might also want whatever but it's not
sensible to do that.  Ignore the user request now, if we see real-world use
for that we'll implement it in the midlayer.  And if you think it's really
important implement it in the midlayer now and keep the patch around for
users that want it.

