From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Tue, 12 Jun 2007 00:43:12 -0400
Message-ID: <466E2460.3050703@garzik.org>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com> <466E1EC6.90509@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <466E1EC6.90509@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Tejun Heo <htejun@gmail.com>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

We will do AHCI link PM -- presuming that I can be convinced that it 
does not repeatedly park the hard drive heads, or something similarly 
annoying on PATA<->SATA bridges and similar setups.

IF it works as advertised -- a big if considering all the AHCI silicon 
implementations out there -- we definitely want to use it.

	Jeff



