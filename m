From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: is there a clean way to disable a scsi timer
Date: Thu, 3 Oct 2002 18:15:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10210031815.ZM119610@classic.engr.sgi.com>
References: <08628CA53C6CBA4ABAFB9E808A5214CB0C4DAF@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: "Heinz, Michael" <mheinz@infiniconsys.com>
        "RE: is there a clean way to disable a scsi timer" (Sep 28, 11:47am)
List-Id: linux-scsi@vger.kernel.org
To: "Heinz, Michael" <mheinz@infiniconsys.com>, "Infante, Jon" <Jon.Infante@Emulex.Com>, linux-scsi@vger.kernel.org

On Sep 28, 11:47am, Heinz, Michael wrote:
> 
> Jon, Jeremy:
> 
> What is the intent in having the device driver do timeout handling? I ask because I've run into some issues with the midlayer timeouts not always working correctly and I've been thinking about implementing timeout processing in my driver. Was that the issue you had or was it something else?
> 
> --
> Michael Heinz
> Staff Software Engineer
> Infinicon Systems, Inc.
> http://www.infiniconsys.com 

In my case, I'm trying to insert something under the mid-layer,
in which all timeouts are handled underneath.

Also, in some cases with Fibrechannel, such as a loss of signal, or
device disappearance, we want to give the device more time to return.

jeremy
