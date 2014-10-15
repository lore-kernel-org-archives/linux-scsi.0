From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Date: Tue, 14 Oct 2014 21:06:37 -0400
Message-ID: <yq1r3ya6t0i.fsf@sermon.lab.mkp.net>
References: <20141010074901.GA32028@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20141010074901.GA32028@sucs.org> (Sitsofe Wheeler's message of
 "Fri, 10 Oct 2014 08:49:01 +0100")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> A previous patch attempted to add a quirk to workaround this
Sitsofe> but the quirk was only enabled after the features had been
Sitsofe> scanned for, wouldn't work for "small" disks 

What does that mean, exactly?

-- 
Martin K. Petersen	Oracle Linux Engineering
