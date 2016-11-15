From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ata: xgene: Enable NCQ support for APM X-Gene SATA
 controller hardware v1.1
Date: Tue, 15 Nov 2016 11:21:18 -0500
Message-ID: <20161115162118.GA30547@htj.duckdns.org>
References: <1469524857-3720-1-git-send-email-rsahu@apm.com>
 <CAFd313x-mXpy0N3aKx2rfoag1FNOrN-LzKb5UHkY2L+GGc0B-A@mail.gmail.com>
 <20161109164531.GA14630@htj.duckdns.org>
 <CAFd313ycmpdp7wHCVRJrigJV31hLwBGOo=FNENwgFnNKyVkQBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFd313ycmpdp7wHCVRJrigJV31hLwBGOo=FNENwgFnNKyVkQBA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Rameshwar Sahu <rsahu@apm.com>
Cc: Olof Johansson <olof@lixom.net>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Devicetree List <devicetree@vger.kernel.org>, linux-arm <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Rameshwar.

On Fri, Nov 11, 2016 at 01:36:28PM +0530, Rameshwar Sahu wrote:
> Hi Tejun,
> 
> On Wed, Nov 9, 2016 at 10:15 PM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > On Wed, Sep 14, 2016 at 04:15:00PM +0530, Rameshwar Sahu wrote:
> >> > @@ -821,8 +823,6 @@ static int xgene_ahci_probe(struct platform_device
> >> > *pdev)
> >> >                                 dev_warn(&pdev->dev, "%s: Error reading
> >> > device info. Assume version1\n",
> >> >                                         __func__);
> >> >                                 version = XGENE_AHCI_V1;
> >> > -                       } else if (info->valid & ACPI_VALID_CID) {
> >> > -                               version = XGENE_AHCI_V2;
> >
> > Can you please explain this part a bit?  Everything else looks good to
> > me.
> 
> Here we should not assume XGENE_AHCI_V2 always in case of having valid
> _CID in ACPI table.
> I need to remove this assumption because V1_1 has also valid _CID for
> backward compatibly with v1.

Can you please repost with the above explanation added to the commit
message?

Thanks!

-- 
tejun
