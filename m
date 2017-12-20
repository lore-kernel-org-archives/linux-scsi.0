From: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [-next PATCH 3/4] treewide: Use DEVICE_ATTR_RO
Date: Wed, 20 Dec 2017 22:38:22 +0100
Message-ID: <87tvwlcc6p.fsf@belgarion.home>
References: <cover.1513706701.git.joe@perches.com>
 <2e64e7d278fa9e4e255221fb84717884a7bfb69c.1513706701.git.joe@perches.com>
 <5619005.tOTWM00GFv@aspire.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <5619005.tOTWM00GFv@aspire.rjw.lan> (Rafael J. Wysocki's message
 of "Wed, 20 Dec 2017 20:00:43 +0100")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Joe Perches <joe@perches.com>
Cc: Don Brace <don.brace@microsemi.com>, linux-nvme@lists.infradead.org, Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org, David Airlie <airlied@linux.ie>, esc.storagedev@microsemi.com, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, Jaroslav Kysela <perex@perex.cz>, Keith Busch <keith.busch@intel.com>, Russell King <linux@arm.osuosl.org>, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Yoshinor i Sato <ysato@users.sourceforge.jp>, Takashi Iwai <tiwai@suse.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>, linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
List-Id: linux-scsi@vger.kernel.org

"Rafael J. Wysocki" <rjw@rjwysocki.net> writes:

> On Tuesday, December 19, 2017 7:15:08 PM CET Joe Perches wrote:
>> Convert DEVICE_ATTR uses to DEVICE_ATTR_RO where possible.
>> 
>> Done with perl script:
>> 
>> $ git grep -w --name-only DEVICE_ATTR | \
>>   xargs perl -i -e 'local $/; while (<>) { s/\bDEVICE_ATTR\s*\(\s*(\w+)\s*,\s*\(?(?:\s*S_IRUGO\s*|\s*0444\s*)\)?\s*,\s*\1_show\s*,\s*NULL\s*\)/DEVICE_ATTR_RO(\1)/g; print;}'
>> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  arch/arm/mach-pxa/sharpsl_pm.c                       |  4 ++--

For mach-pxa:
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
