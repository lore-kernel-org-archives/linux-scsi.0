From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v5 0/6] firmware_loader: cleanups for v4.18
Date: Tue, 8 May 2018 15:24:18 +0000
Message-ID: <20180508152418.GB27853@wotan.suse.de>
References: <20180504174356.13227-1-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180504174356.13227-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, bjorn.andersson@linaro.org, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@davemloft.net, maco@android.com, arve@android.c
List-Id: linux-scsi@vger.kernel.org

On Fri, May 04, 2018 at 10:43:49AM -0700, Luis R. Rodriguez wrote:
> Greg,
> 
> I've reviewed the pending patches for the firmware_laoder and as for
> v4.18, the following 3 patches from Andres have been iterated enough
> that they're ready after I made some final minor changes, mostly just
> style fixes and re-arrangements in terms of order. The new API he was
> suggesting to add requires just a bit more review.

We're done with review of the new API for the sync no warn call,
so I'll just re-issue another patch series with those patches
in a new series.

Coming right up.

  Luis
