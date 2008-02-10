From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Date: Sun, 10 Feb 2008 18:24:00 -0500
Message-ID: <47AF8790.1040706@torque.net>
References: <20080208153217.5fc42a50@core>	<47AD02C6.70402@torque.net> <20080209135020.6eca03ac@core>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756533AbYBJXYX@vger.kernel.org>
In-Reply-To: <20080209135020.6eca03ac@core>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Alan Cox wrote:
> On Fri, 08 Feb 2008 20:32:54 -0500
> Douglas Gilbert <dougg@torque.net> wrote:
> 
>> Alan Cox wrote:
>>> The word "illegal" has a precise dictionary meaning of "prohibited by
>>> law". 
>> Also "contrary to or forbidden by official rules, regulations, etc".
> 
> The OED I have here doesn't seem to think so, however if the words are
> the ones used in the T10 documentation then I'm happy to drop the patch.

The OED (Oxford English dictionary) seems to be at odds
with most other online dictionaries with respect to the
word illegal. I find the following 'illegal' entry
(at www.askoxford.com) daft:
  "USAGE Both illegal and unlawful can mean 'contrary to
   or forbidden by law', but unlawful has a broader meaning
   'not permitted by rules': thus handball in soccer is
   unlawful, but not illegal."

So if we followed the OED's advice then SCSI's "illegal
request" would become "unlawful request". I'm yet to
see the word "unlawful" in any technical standard ...

Doug Gilbert
