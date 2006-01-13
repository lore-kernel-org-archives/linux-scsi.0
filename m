From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/10] iscsi: data under/over flow fix
Date: Fri, 13 Jan 2006 18:12:31 +0000
Message-ID: <20060113181231.GK20718@infradead.org>
References: <1137128907.9508.35.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45955 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422787AbWAMSMc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:12:32 -0500
Content-Disposition: inline
In-Reply-To: <1137128907.9508.35.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 12, 2006 at 11:08:27PM -0600, Mike Christie wrote:
> >From zhenyu.z.wang@intel.com:
> 
> We need to check the ISCSI_FLAG_DATA_* flags.

ok
