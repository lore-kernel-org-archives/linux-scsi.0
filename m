From: Greg KH <greg@kroah.com>
Subject: Re: [ANNOUNCE 2/6] Linux-iSCSI High-Performance Initiator
Date: Mon, 11 Apr 2005 22:35:32 -0700
Message-ID: <20050412053532.GE32372@kroah.com>
References: <425B3F58.2040000@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262013AbVDLFrp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <425B3F58.2040000@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 11, 2005 at 08:24:08PM -0700, Alex Aizman wrote:
> +typedef uint64_t iscsi_snx_t;		/* iSCSI Data-Path session handle */
> +typedef uint64_t iscsi_cnx_t;		/* iSCSI Data-Path connection handle */

Do you really have to create a new typedef?  Please reconsider.  Just
use u64 everywhere, unless you need to do type checking...

thanks,

greg k-h
