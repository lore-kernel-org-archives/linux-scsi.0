From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4] [SCSI] ufshcd: UFS Host controller driver
Date: Sat, 11 Feb 2012 19:52:08 +0000
Message-ID: <201202111952.08745.arnd@arndb.de>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com> <CAGxe1ZGDy-MWetg_rki2ms1Yy0dn4WqfrJgK+wPrucojyt-fHw@mail.gmail.com> <CALMYJDtCc_M8dOna1wfeLai1Fjj3NfcnJb7AcFNgMdvGQtuamA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALMYJDtCc_M8dOna1wfeLai1Fjj3NfcnJb7AcFNgMdvGQtuamA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Girish K S <girish.shivananjappa@linaro.org>, Vinayak Holikatti <vinholikatti@gmail.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, venkat@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Sree kumar <sreekumar.c@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On Friday 10 February 2012, Santosh Y wrote:
> > UFS host controller specification Section 7.2.1, step 11,  mentions
> > that the aggregation control register should be set if run/stop bit is
> > not enabled.
> > But In this case the run/ stop bit is set above before configuring the
> > aggregation register. Please check for the same in other places from
> > where it is called.
> >
> 
> The spec mentions, (Section 7.2.1, step 11)
> "UTRIACR initialization may be executed at any time when the Run/Stop
> register (UTRLRSR)
> is not enabled or when no requests are outstanding."
> 
> At this point in the code, during execution, there will not be any
> outstanding requests.

One meta-comment: When you reply on a long email like this, please
make sure you only quote the minimum amount of lines from the original
email to give enough context for your comment. Otherwise it becomes
much more time consuming to read your reply and readers might miss
your contribution in the middle of a long quote.

	Arnd
