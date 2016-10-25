From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/10] mpt3sas: Fix for incorrect numbers for MSIX vectors
 enabled when non RDPQ card is enumerated first.
Date: Tue, 25 Oct 2016 16:38:10 +0200
Message-ID: <f2a6651e-93f2-8729-5206-117abebf5b7a@redhat.com>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476966018-10457-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 20.10.2016 14:20, Suganath Prabu S wrote:
> No. of MSIX vectors supported = min (Total no. of CPU cores,
> MSIX vectors supported by card)
>
> when RDPQ is disabled "max_msix_vectors" module parameter which was
> declared as global was set to '8' and hence if there are more than one card
> in system among which if RDPQ disabled card is enumerated first then only 8
> MSIX vectors was getting enabled for all the cards(including RDPQ enabled
> card,which can support more than 8 MSIX vectors).
>
> Used local variable instead of global variable ,if RDPQ is disabled this
> local variable is set to '8' else it is set to "max_msix_vectors" (by
> default this is set to -1, whose value can be set by user during driver
> load time).So now regardless of whether RDPQ disabled card is enumerated
> first or RDPQ enabled card is enumerated first , MSIX vectors enabled
> depends on the cards capability.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
