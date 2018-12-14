From: Ivan Mironov <mironov.ivan@gmail.com>
Subject: Re: [PATCH 0/6] Add support of the HBA mode on HP Smart Array P410i
 controllers
Date: Sat, 15 Dec 2018 01:30:06 +0500
Message-ID: <449fb880e94d478fb35e01da93c5b1fa1732f7d8.camel@gmail.com>
References: <20181214132115.21440-1-mironov.ivan@gmail.com>
         <BYAPR11MB285586623125DD1C98EE87F1E1A10@BYAPR11MB2855.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BYAPR11MB285586623125DD1C98EE87F1E1A10@BYAPR11MB2855.namprd11.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Don.Brace@microchip.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-12-14 at 19:38 +0000, Don.Brace@microchip.com wrote:
> NAKing this series.
> - The P410 controllers do not fully support HBA mode and we do not support adding it to the hpsa driver.
> 

Could you please elaborate on what exactly you mean by "do not fully
support HBA mode"?

HBA mode looks supported on P410i (at least to some degree) because:
*) There is an official method to enable/disable it on these
controllers. Only for itanium-based servers unfortunately.
*) This method is mentioned in various documents from HP regarding
Integrity servers.
*) Controller reacts on the change of corresponging bit in nvram_flags
by immediately removing any configured RAID arrays and by refusing to
configure new arrays. Which is totally expected for HBA mode.
*) HBA mode works for me on P410i with patched driver.
