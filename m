From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
Date: Tue, 8 Aug 2017 03:29:52 -0400
Message-ID: <20170808072952.GB9938@localhost.localdomain>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de>
 <20170805135353.GA7526@infradead.org>
 <1501944129.3649.9.camel@HansenPartnership.com>
 <0ada8680ebfeb026662d858ec2b38ef4@mail.gmail.com>
 <1502115492.2841.20.camel@HansenPartnership.com>
 <da1e0ded0c7d4bab1cfa0850488c8fb7@mail.gmail.com>
 <1502120725.2841.28.camel@HansenPartnership.com>
 <20170808040449.GE842@localhost.localdomain>
 <CAK=zhgp6y6bWYBWJSg-8A6x_PYRgq1S83OZcGVghh3LKov7UfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK=zhgp6y6bWYBWJSg-8A6x_PYRgq1S83OZcGVghh3LKov7UfQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 08, 2017 at 12:33:40PM +0530, Sreekanth Reddy wrote:
> On Tue, Aug 8, 2017 at 9:34 AM, Keith Busch <keith.busch@intel.com> wrote:
> >
> > It looks like they can make existing nvme tooling work with little
> > effort if they have the driver implement NVME_IOCTL_ADMIN_COMMAND, and
> 
> Precisely, I was thinking on the same line and you clarified. I will
> spend sometime on this and get back to you.

Sounds good. Just note that while the majority of NVMe management should
be reachable with just that IOCTL, some tooling features may not work
correctly since they look for /dev/nvmeX, and I assume this driver will
create /dev/sdX instead.
