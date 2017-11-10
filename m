From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/7] scsi: bfa: do_gettimeofday removal
Date: Fri, 10 Nov 2017 18:24:35 +0100
Message-ID: <20171110172435.GB15288@lst.de>
References: <20171110153715.1929456-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171110153715.1929456-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, hch@lst.de, hare@suse.com, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

This stuff look ok - but I have a bigger question and that is if
bfa is still alive at all.  Everytime I look at it I have doubts if
it works at all, so I wonder if we need to keep it on life support.
