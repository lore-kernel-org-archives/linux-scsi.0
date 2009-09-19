From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] libiscsi: iscsi_session_setup to allow for private
 space
Date: Fri, 18 Sep 2009 20:13:58 -0500
Message-ID: <4AB43056.10606@cs.wisc.edu>
References: <20090918161628.GA8436@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59482 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZISBOH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 21:14:07 -0400
In-Reply-To: <20090918161628.GA8436@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

Jayamohan Kallickal wrote:
> 	This patch contains changes that allow iscsi_session_setup
>  to allocate private space for LLD's
> 
> Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
>  drivers/scsi/be2iscsi/be_iscsi.c         |    6 ++++--
>  drivers/scsi/be2iscsi/be_main.h          |    5 +++++
>  drivers/scsi/bnx2i/bnx2i_iscsi.c         |    2 +-
>  drivers/scsi/cxgb3i/cxgb3i_iscsi.c       |    2 +-
>  drivers/scsi/iscsi_tcp.c                 |    2 +-
>  drivers/scsi/libiscsi.c                  |    6 ++++--
>  include/scsi/libiscsi.h                  |    3 ++-
>  8 files changed, 19 insertions(+), 9 deletions(-)
>

Looks ok

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
