From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/8] iscsi_transport: Additional parameters for net settings
Date: Tue, 28 May 2013 03:50:29 -0500
Message-ID: <51A46FD5.2070702@cs.wisc.edu>
References: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com> <1368093732-8524-3-git-send-email-vikas.chaudhary@qlogic.com> <51A46F8D.4040701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45437 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933576Ab3E1Iui (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 May 2013 04:50:38 -0400
In-Reply-To: <51A46F8D.4040701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

On 05/28/2013 03:49 AM, Mike Christie wrote:
> Come on man, same comments as last patches like this :) Could you use
> the same names that we currently use for existing params?
> 
> Check for the inorder ones and the ones where we use en instead of
> enabled for the postfix. Also check the others.
> 
> Also what is up with isns. If we support passing the addr/port/enabled
> then will it work completely in fw? You do not need any driver or
> userspace changes for that?

For isns support does what you are adding work for flash mode only?

