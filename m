From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] ata: xgene: Enable NCQ support for APM X-Gene SATA
 controller hardware v1.1
Date: Wed, 18 Jan 2017 11:23:08 -0800
Message-ID: <20170118192308.GC9171@mtj.duckdns.org>
References: <1479462345-13942-1-git-send-email-rsahu@apm.com>
 <CAFd313wajZzZWGQy20obf4k_7RO43Q10NiBa-8TVYxo3J93inA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAFd313wajZzZWGQy20obf4k_7RO43Q10NiBa-8TVYxo3J93inA@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Rameshwar Sahu <rsahu@apm.com>
Cc: Devicetree List <devicetree@vger.kernel.org>, mlangsdo@redhat.com, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>, linux-ide@vger.kernel.org, Olof Johansson <olof@lixom.net>, linux-arm <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Jan 17, 2017 at 08:25:21PM +0530, Rameshwar Sahu wrote:
> Hi Tejun,
> 
> On Fri, Nov 18, 2016 at 3:15 PM, Rameshwar Prasad Sahu <rsahu@apm.com> wrote:
> > This patch enables NCQ support for APM X-Gene SATA controller hardware v1.1
> > that was broken with hardware v1.0. Second thing, here we should not assume
> > XGENE_AHCI_V2 always in case of having valid _CID in ACPI table. I need to
> > remove this assumption because V1_1 also has a valid _CID for backward
> > compatibly with v1.
> >
> > v2 changes:
> >         1. Changed patch description
> >
> > Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>

Hmm... I don't have the patch in my queue.  Can you please resend it?

Thanks.

-- 
tejun
