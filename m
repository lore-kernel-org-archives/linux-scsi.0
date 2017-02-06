From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/39] megaraid_sas: megasas_get_request_descriptor always return valid desc
Date: Mon, 06 Feb 2017 18:54:33 -0500
Message-ID: <yq1lgtiub7q.fsf@oracle.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <1486375212-17329-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <9c5b079b-b73b-ae09-60ae-47c04e708537@suse.com>
        <b3af1748b00ac22a5cba585a80462b53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31418 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbdBFXyq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:54:46 -0500
In-Reply-To: <b3af1748b00ac22a5cba585a80462b53@mail.gmail.com> (Shivasharan
        Srikanteshwara's message of "Mon, 6 Feb 2017 19:14:23 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>

>>>>> "Shivasharan" == Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com> writes:

Shivasharan,

Shivasharan> Are you OK if I re-send only above impacted patch or like
Shivasharan> to see complete series with v2 tag and updated patch
Shivasharan> numbers?

Please send a complete v2 with all the little issues fixed up.

Also, please remove all the "This patch depends on ..." stuff from the
patch descriptions. The dependencies are inherent in the ordering of the
patches and we don't want that in the commit messages.

-- 
Martin K. Petersen	Oracle Linux Engineering
