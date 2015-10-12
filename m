From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SSP frame iu defines
Date: Mon, 12 Oct 2015 07:55:20 -0700
Message-ID: <1444661720.2205.5.camel@HansenPartnership.com>
References: <56167B0D.5040303@huawei.com> <5172892.J8LUuCdX1I@wuerfel>
	 <56168208.2020404@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34626 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbbJLOzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 10:55:22 -0400
In-Reply-To: <56168208.2020404@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, hare@suse.de, zhangfei <zhangfei.gao@linaro.org>, john.garry2@mail.dcu.ie, "xuwei (O)" <xuwei5@hisilicon.com>

On Thu, 2015-10-08 at 15:47 +0100, John Garry wrote:
> On 08/10/2015 15:22, Arnd Bergmann wrote:
> > On Thursday 08 October 2015 15:17:49 John Garry wrote:
> >> Hi,
> >>
> >> For a new driver I am preparing for a SAS controller, I need defintions
> >> for the SSP command and TMF iu structures. Currently these are defined
> >> in the following:
> >> ssp_command_iu, ssp_task_iu: drivers/scsi/aic94xx_sas.h
> >> ssp_cmd_iu, ssp_task_iu: drivers/scsi/isci/sas.h
> >>
> >> I plan to move them to include/scsi/sas.h . Any objections?
> >
> > Hi John,
> >
> > I think a question like this is better asked by sending a patch,
> > to make it easier to see what the resulting change is.
> >
> > 	Arnd
> >
> >
> OK, can I put this together.
> I feel that the code may get messy due to byte-ordering difference in 
> isci versions.

That's why we develop with the show me the code model.  Rather than
arguing theoretically about whether something should or should not be
done, you propose the actual change.  If it looks like a dog's breakfast
and all attempts to clean it up fail, chances are it's a bad change and
it won't go in.  However, if it looks good, chances are it will.

James


