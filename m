From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: Re: [PATCH v2 22/30] scsi: aacraid: Merge adapter setup with resolve luns
Date: Wed, 03 Jan 2018 11:02:04 +0100
Message-ID: <87h8s31crn.fsf@suse.cz>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
        <20171227043451.27813-23-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36959 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751427AbeACKCH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jan 2018 05:02:07 -0500
In-Reply-To: <20171227043451.27813-23-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Tue, 26 Dec 2017 20:34:43
        -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com> writes:

> The device hotplug events are processed only after retrieving the updated
> lun information from the fw. Does not make sense to keep them separate.
>
> Merge both the hotplug handling and safw adapter setup code into single
> function.
>
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

According to subsequent commit

  [PATCH v2 23/30] scsi: aacraid: Block concurrent hotplug event handling

this commit is racy, because 23/30 adds ->scan_mutex. Shouldn't be these
commits squashed?

--
Nikola
