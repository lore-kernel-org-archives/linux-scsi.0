From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 13/15] qla4xxx: Added bsg support
Date: Fri, 11 Jun 2010 19:23:52 -0500
Message-ID: <4C12D398.8020200@cs.wisc.edu>
References: <20100611074900.GA27827@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53681 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab0FLAVn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 20:21:43 -0400
In-Reply-To: <20100611074900.GA27827@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com

On 06/11/2010 02:49 AM, Vikas Chaudhary wrote:
> Added BSG support to enable application support to configure
> ISP40XX/ISP82XX adapter.
>
> This patch is on top of: http://marc.info/?l=linux-scsi&m=126999297630764&w=2
>

Did James say that using vendor specific commands was ok? I did not see 
anything on the list. If he did, then instead of the patch above from 
Jay, you want to use iscsi bsg patches that I sent that handle Tomos's 
comments about not duplicating fc code. I sent the bsg lib to the list 
and then in my tree on kernel.org I ported the fc drivers (those might 
need a update for some patches James Smart recently sent). For those bsg 
patches you will want to then also add the vendor specific command back.
