From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Tue, 17 Jan 2017 15:15:25 +0100
Message-ID: <20170117141525.GA32219@lst.de>
References: <20161229080250.GA11605@infradead.org> <1483226343.2518.32.camel@linux.vnet.ibm.com> <1483280506.5512.1.camel@sandisk.com> <20170101.113311.417107391370623850.davem@davemloft.net> <1483292364.2345.5.camel@linux.vnet.ibm.com> <yq1y3ypgd7m.fsf@oracle.com> <1484596878.2540.58.camel@HansenPartnership.com> <CAK=zhgpFKLWUpQMp8VOfmHsUCQiF6E54FBP2juaHYNVvR+TOmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK=zhgpFKLWUpQMp8VOfmHsUCQiF6E54FBP2juaHYNVvR+TOmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, David Miller <davem@davemloft.net>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, jbaron@akamai.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, sagi@grimberg.me, Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Chaitra Basappa <chaitra.basappa@broadcom.com>, dledford@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 17, 2017 at 07:43:51PM +0530, Sreekanth Reddy wrote:
> [Sreekanth] Just for readability purpose, can use use "if (test_bit(0,
> &sas_device_priv_data->ata_command_pending)"
>  instead of "if (sas_device_priv_data->ata_command_pending)".
> Since while setting & clearing the bit we are using atomic bit
> operations. I don't see any issue functionality wise.

I agree.  Also while we're into nitpicking - it would be good to
give bit 0 of the bitmap a name instead of hardcoding the 0.

Except for these patch looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
