From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH 2/2] ata: acpi: rework the ata acpi bind support
Date: Thu, 22 Aug 2013 15:15:16 +0800
Message-ID: <5215BA84.20000@intel.com>
References: <1374731223-28685-1-git-send-email-aaron.lu@intel.com> <1374731223-28685-3-git-send-email-aaron.lu@intel.com> <20130725145229.GB26107@mtj.dyndns.org> <520C2FE8.90009@intel.com> <20130815031954.GB4439@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130815031954.GB4439@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Dirk Griesbach <spamthis@freenet.de>, Dimitris Damigos <damigos@freemail.gr>, Dan van der Ster <dan@vanderster.com>, Jeff Wu <jeff.wu@amd.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, Shane Huang <shane.huang@amd.com>, Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>, Zhang Rui <rui.zhang@intel.com>, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/15/2013 11:19 AM, Tejun Heo wrote:
> Hello, Aaron.
> 
> On Thu, Aug 15, 2013 at 09:33:28AM +0800, Aaron Lu wrote:
>> This has been quiet for some time, may I know your opinion on this?
> 
> Ooh, I like it. I was waiting for proper patch series w/o RFC tag and
> hopefully some test results.

The patch series has two patches and the first has been taken, shall I
send the 2nd one again without the RFC tag in the patch subject? There
should be no other changes at the moment.

As for the test, I've tested runtime power management related code, but
I don't have access to PMP and ATA bay, so I'll ask some people to help.

Hi Drik,
Can you please test the two patches regarding your ATA bay? Thanks.

Hi Dimitris,
Can you please test the two patches regarding ACPI per device disable
functionality? Thanks.

Hi Dan,
Can you please test the two patches here regarding PMP? Thanks.

Hi Jeff,
It would be good if you can test AMD's ZPODD implementation with the
patches here, thanks.

You can either use the branch here:
https://github.com/aaronlu/linux ata_acpi_rework

Or apply the following two patches on top of Linus' tree or a stable tree:
https://github.com/aaronlu/linux/commit/88ba5478837098b71573bb7d6002be33156ea7e4
https://github.com/aaronlu/linux/commit/98b61e1f52fe5582eb7f18c6d27773bf1da70096

Thanks,
Aaron
