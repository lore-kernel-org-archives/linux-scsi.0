From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/5] ata: Add APM X-Gene SATA driver
Date: Tue, 12 Nov 2013 14:11:53 +0100
Message-ID: <201311121411.54423.arnd@arndb.de>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
 <201311110954.32904.arnd@arndb.de>
 <CAPw-ZT=aVyw2yducpQMD2_rPPV7abKJZOH-Fs3bT2Ja=0tUNSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAPw-ZT=aVyw2yducpQMD2_rPPV7abKJZOH-Fs3bT2Ja=0tUNSQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Loc Ho <lho@apm.com>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, Jon Masters <jcm@redhat.com>, Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 12 November 2013, Loc Ho wrote:
> Hi Arnd/Olof,
> 
> I looked over the phy code for USB and NET. There isn't such PHY
> infrastructure for SATA from what I can tell. It seems like I will
> need to put this all together. I am thinking about porting the USB
> version over (with changes for SATA) and put it under
> "./drivers/ata/phy". Any suggestion?

Please have a look at the patches under the subject "Generic PHY Framework"
posted by Kishon Vijay Abraham. I thought they would have made it in
by now, but I have not followed the recent kernels closely since I am
on parental leave at the moment.

IIRC they should unify USB, SATA and other PHY codes, but not network.

	Arnd
