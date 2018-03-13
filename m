From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: eata: drop VLA in reorder()
Date: Mon, 12 Mar 2018 22:35:36 -0400
Message-ID: <yq1y3iwem87.fsf@oracle.com>
References: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com>
        <20180312030834.GC8631@eros>
        <CA+55aFww=otC4Wv40enadF+9NAyWG4Hotzjvv2EKb+_wGFui-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFww=otC4Wv40enadF+9NAyWG4Hotzjvv2EKb+_wGFui-w@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 12 Mar 2018 11:45:53 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <tobin@apporbit.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, kernelnewbies@kernelnewbies.org
List-Id: linux-scsi@vger.kernel.org


Linus,

> That said, I wonder if the solution to this particular driver is
> "delete it". Because the hardware is truly ancient and nobody sane
> would use it any more.

I'm not aware of anybody actively using these anymore. They are
mid-nineties vintage with an M68K processor onboard. I ran a couple of
these when they were new but haven't had a working board in probably a
decade.

No objections to Salvatore's patch but I have a slight affinity for
retiring unused code over patching it. So unless there are objections...

-- 
Martin K. Petersen	Oracle Linux Engineering
