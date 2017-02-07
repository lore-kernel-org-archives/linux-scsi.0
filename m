From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/39] megaraid_sas: megasas_get_request_descriptor always return valid desc
Date: Mon, 06 Feb 2017 19:02:42 -0500
Message-ID: <yq1h946uau5.fsf@oracle.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <1486375212-17329-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <9c5b079b-b73b-ae09-60ae-47c04e708537@suse.com>
        <b3af1748b00ac22a5cba585a80462b53@mail.gmail.com>
        <yq1lgtiub7q.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40814 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdBGADZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 19:03:25 -0500
In-Reply-To: <yq1lgtiub7q.fsf@oracle.com> (Martin K. Petersen's message of
        "Mon, 06 Feb 2017 18:54:33 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> Also, please remove all the "This patch depends on ..." stuff
Martin> from the patch descriptions. The dependencies are inherent in
Martin> the ordering of the patches and we don't want that in the commit
Martin> messages.

And please make sure to apply the review tags you got from Hannes and
Tomas to those patches that remain unchanged...

-- 
Martin K. Petersen	Oracle Linux Engineering
