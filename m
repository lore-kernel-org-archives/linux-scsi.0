From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Tue, 22 Mar 2011 20:06:30 -0700
Message-ID: <1300849590.21880.411.camel@haakon2.linux-iscsi.org>
References: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55328 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab1CWDNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2011 23:13:42 -0400
In-Reply-To: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>

On Tue, 2011-03-22 at 20:06 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi James and Co,
> 
> Here is an updated v2 mergeable + squashable version of iscsi_target_mod based
> upon Mike Christie's recent feedback which contains two additional minor changes
> to iscsi_proto.h and target core.  Thanks for your review Mike!
> 
> This patch series is made against the following scsi-misc-2.6.git/master HEAD:
> 
> commit aa7131dcdb262cd08bc39a15ebd788a6bc0cda2f
> Author: James Bottomley <James.Bottomley@suse.de>
> Date:   Fri Mar 18 11:24:23 2011 -0400
> 
>     [SCSI] ses: add subenclosure support
> 
> Please merge patch #1 + #2 as a seperate iscsi commits after Mike's review
> and signoff.  Patch #3 is a seperate target_core int_to_scsilun() conversion
> patch so we can drop target_core_fabric_ops->pack_lun() for the initial merge
> of iscsi-target.
> 
> >From there squash #4 -> #14 using the commit message message of patch #4 for
> an initial commit for iscsi-target.
> 
> I will follow with any further comments from Christoph, Mike & Co.
> 

Here is the missing v1 -> v2 changelog btw:

*) Remove mixed case in iscsi_target_auth.c
*) Remove unnecessary ____cacheline_aligned usage
*) Cleanup code to use iscsit_release_cmd()
*) Convert to use scsilun_to_int and int_to_scsilun
*) Convert iscsi_session->session_[usage_count,waiting_on_uc] to int
*) Convert iscsi_conn->conn_[usage_count, waiting_on_uc] to int
*) Convert to use iscsi_proto.h iscsi_sna_gt
*) Remove unused iscsit_ntoa
*) Remove unused inet conversions
*) Remove unused struct net_device state checks
*) Convert to use kernel_[send,recv]msg() and struct kvec
*) Use single np->np_ip and conn->login_ip for AF_INET*
*) Use list_is_last() in iscsit_[free,stop]_session()
*) Fix up lio_target_call_delnpfromtpg output

Thanks again to Mike Christie for his review!

--nab


