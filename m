From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: Backport of a fix for HPSA (Disabling a disabled device problem
 during kdump) driver
Date: Tue, 06 Jan 2015 17:15:19 +0100
Message-ID: <54AC0A17.8020405@redhat.com>
References: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Masoud Sharbiani <msharbiani@twopensource.com>, stable@vger.kernel.org
Cc: Don Brace <Don.Brace@pmcs.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/05/2015 07:41 PM, Masoud Sharbiani wrote:
> Dear stable maintainers,
> Can you please backport commitid 132aa220b45d60e9b20def1e9d8be9422eed9616
>  (hpsa: refine the pci enable/disable handling) to 3.10 stable (and
> earlier, if applicable)?

Please do not apply this patch isolated from his friend, the
859c75aba20264d87dd026bab0d0ca3bff385955 hpsa: add missing pci_set_master in kdump path
needs to be applied together with the 132aa220b45d60e9b20def1e9d8be9422eed9616 .

In addition to that, after the original issue goes away you may notice sometimes
an unhandled irq 16 message, to fix this a patch is posted 
here http://www.spinics.net/lists/linux-scsi/msg80316.html
This patch still awaits a maintainers review though.

Probably the best idea is to wait until the issue is solved completely.

Tomas
 

> I've tried the 3.10, and it applies cleanly there. Not sure about
> earlier versions.
> Many Thanks,
> Masoud Sharbiani
> Twitter Inc.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
