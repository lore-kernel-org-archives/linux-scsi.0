From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: sg: Prevent potential double frees in sg driver
Date: Sat, 5 Aug 2017 13:37:47 +0200
Message-ID: <20170805113747.GE16313@lst.de>
References: <20170803190248.51537-1-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170803190248.51537-1-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: hare@suse.de, jthumshirn@suse.de, hch@lst.de, salyzyn@google.com, gregkh@linuxfoundation.org, Robb Glasser <rglasser@google.com>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This looks correct and safe to me, but I wonder if anyone relies
on multi-threaded /dev/sg write usage, which would be completely
serialized with this.
