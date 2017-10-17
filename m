From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: Fix controller initialization failure
Date: Mon, 16 Oct 2017 23:18:26 -0400
Message-ID: <yq1tvyyzcl9.fsf@oracle.com>
References: <150819975151.22574.15488858870979477962.stgit@rslab209.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23424 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753664AbdJQDSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 23:18:34 -0400
In-Reply-To: <150819975151.22574.15488858870979477962.stgit@rslab209.pmc-sierra.bc.ca>
        (Raghava Aditya Renukunta's message of "Mon, 16 Oct 2017 17:22:31
        -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Scott.Benesh@microsemi.com


Raghava,

> This is a fix to an issue where the driver sends its periodic WELLNESS
> command to the controller after the driver shut it down.This causes
> the controller to crash. The window where this can happen is small,
> but it can be hit at around 4 hours of constant resets.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
