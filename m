From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 5/8] mpt3sas: Fix _transport_smp_handler() error path
Date: Tue, 19 Jun 2018 07:18:55 +0200
Message-ID: <20180619051855.GD22076@lst.de>
References: <20180615214201.25365-1-bart.vanassche@wdc.com> <20180615214201.25365-6-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180615214201.25365-6-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 02:41:58PM -0700, Bart Van Assche wrote:
> This patch avoids that smatch complains about a double unlock on
> ioc->transport_cmds.mutex.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
