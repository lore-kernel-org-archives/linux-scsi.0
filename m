From: Jeff Garzik <jeff@garzik.org>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sun, 09 Sep 2007 17:11:44 -0400
Message-ID: <46E46190.6080607@garzik.org>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760613AbXIIVOJ@vger.kernel.org>
In-Reply-To: <20070909210329.GE25798@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andi Kleen wrote:
>> I can see where you're coming from, but logically, this is wrong.
>> There's a huge slew of enterprise machines that only have DVD on SATA.
> 
> ... and enterprise systems don't really care about a few KB more of code.
> In fact you definitely want to have SATA compiled in in case you need
> to recover the machine later when the SAN is down.
> 
>> On the other hand, all of these machines will have SCSI disk devices on
>> various other transports, so no harm is done, it's just an inelegant
>> solution.
> 
> Do you know of a better one?

Let's step back a moment and consider the actual scale and impact of the 
problem at hand.

The vast majority of users are consumers of pre-compiled kernels, built 
by People With Clue(tm), who figured this stuff out as soon as it was 
introduced.

The current setup expresses the dependencies as they exist -- OPTIONAL 
extras, and that is a problem once a year or so, when someone builds 
their own kernel but must learn this fact anew.

There is simply no compelling need at all to change things from the 
current setup.

Our Kconfig system is for people who already know the kernel, not Aunt 
Tillie.

	Jeff
