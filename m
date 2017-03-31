From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH v2] sd: Consider max_xfer_blocks if opt_xfer_blocks is
 unusable
Date: Fri, 31 Mar 2017 12:05:25 +0800
Message-ID: <20170331040525.GA11195@lemon.lan>
References: <20170328044126.10006-1-famz@redhat.com>
 <yq1k2774hht.fsf@oracle.com>
 <20170330041311.GA32392@lemon.lan>
 <yq18tnm3hou.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq18tnm3hou.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 03/30 11:30, Martin K. Petersen wrote:
> Fam Zheng <famz@redhat.com> writes:
> 
> >> 	rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
> >>                               BLK_DEF_MAX_SECTORS);
> >
> > Yes, it is better. Is it okay to make the change when you apply?
> 
> Sure. Applied to 4.11/scsi-fixes.

Cool. Thanks!

Fam
