From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx 6.2.24 bug report
Date: Sat, 28 Dec 2002 15:28:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <834928112.1041114482@aslan.scsiguy.com>
References: <20021228204505.GC9319@linnie.riede.org>
 <766648112.1041108533@aslan.scsiguy.com>
 <20021228222620.GE9319@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021228222620.GE9319@linnie.riede.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org



> On 2002.12.28 15:48 Justin T. Gibbs wrote:
>> Can you retest enabling the debug features of the driver and setting
>> the debug mask to 0x63?  Something like, assuming you are using a
>> module:
>> 
>> options aic7xxx aic7xxx=verbose.debug:0x63
				  ^<= '.' not ','

>> 
> What am I doing wrong?

You're using characters that the shell might expand.  If
you quote the option string, the choice of ',' or '.' shouldn't
matter.

--
Justin

