From: "Jeff Leung" <jleung@v10networks.ca>
Subject: RE: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Date: Mon, 20 Oct 2014 22:19:31 -0700
Message-ID: <A70AC0C1B7E7FD478A6BF19705461AA01109B5@IMBER.smb.curriegrad2004.ca>
References: <20141010074901.GA32028@sucs.org>
 <20141011173902.GA1946@infradead.org> <1413049313.2068.48.camel@jarvis.lan>
 <b0069f11bbe64ebc8c9981ea90429014@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <A70AC0C1B7E7FD478A6BF19705461AA01109B3@IMBER.smb.curriegrad2004.ca>
 <da5106ddc725481784ed12bccb594980@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20141021044550.GC11691@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-class: urn:content-classes:message
In-Reply-To: <20141021044550.GC11691@sucs.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Sitsofe Wheeler <sitsofe@gmail.com>, KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

> Is it OK to replace a scsi_level of SCSI-2 with SCSI_SPC_3? Additionally is it also OK to force
> SCSI_SPC_3 on Hyper-V 2008?

I would patch the driver accordingly to force the SPC-3 flag.

For a Win2k8 host, I don't know what the side effects are, so it's safe to say it's not a good idea to
Force SCSI_SPC_3
