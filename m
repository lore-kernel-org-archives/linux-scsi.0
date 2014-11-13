From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Thu, 13 Nov 2014 06:29:07 -0800
Message-ID: <20141113142907.GB29354@infradead.org>
References: <54629CAE.2000207@laposte.net>
 <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com>
 <5462CB90.1080303@roeck-us.net>
 <54642541.9080302@laposte.net>
 <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net>
 <54647C10.4070506@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54647C10.4070506@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Barto <mister.freeman@laposte.net>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

Guenters commit just fixes the inversion from commit

71e75c97f97a9645d25fbf3d8e4165a558f18747 scsi: convert device_busy to atomic_t

Can you please test the commit before that:
74665016086615bbaa3fa6f83af410a0a4e029ee scsi: convert host_busy to atomic_t

and check if that works for you or not.
