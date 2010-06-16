From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH 0/5] Fix set but unused variable warnings
Date: Wed, 16 Jun 2010 21:30:23 +1000
Message-ID: <AANLkTil-d7LqofvvB9_QGd7Quy4kPucWGpJ5LHl94LoP@mail.gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	<AANLkTikwKHITQJDaSf9BnHQ9FLiQ-KYlCWNiH438otsV@mail.gmail.com>
	<20100616110914.GF9298@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20100616110914.GF9298@parisc-linux.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 16, 2010 at 21:09, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Jun 16, 2010 at 03:52:58PM +1000, Julian Calaby wrote:
>> Given that patches 3, 4 and 5 seem to be a cases of missing error
>> handling, (3 and 4 in particular seem to be breaking things rather
>> than fixing them) in my humble opinion, I think this set needs some
>> work and discussion.
>>
>> Justin, maybe you'd be better off posting the actual error messages
>> (split up by subsystem) and letting the lists discuss them, rather
>> than posting patches which are obviously wrong. (like the ones I've
>> pointed out)
>
> My first impression of patch 5 was "that can't be right", but upon re=
view,
> I concluded that was the best solution. =A0If we return the PTR_ERR, =
this
> is going to confuse every user of scsi_host_alloc who are currently o=
nly
> checking for NULL.

I did a double take at patch 4 when skimming over them, then took a
proper look at the lot of them. Whilst I agree that 5 isn't doing
anything particularly bad, it does seem wrong, especially in the
context of 3 and 4.

Thanks,

--=20

Julian Calaby

Email: julian.calaby@gmail.com
=2EPlan: http://sites.google.com/site/juliancalaby/
