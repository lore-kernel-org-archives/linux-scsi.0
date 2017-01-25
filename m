From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] qla2xxx: Avoid that issuing a LIP triggers a kernel crash
Date: Wed, 25 Jan 2017 18:29:44 -0500
Message-ID: <yq1pojabtw7.fsf@oracle.com>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
        <20170123163446.9227-3-bart.vanassche@sandisk.com>
        <91a8f843-c969-72c4-1add-8e44ea2d9a8a@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <91a8f843-c969-72c4-1add-8e44ea2d9a8a@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Tue, 24 Jan 2017 12:59:57
        -0200")
Sender: stable-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Naresh Bannoth <nbannoth@in.ibm.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Hi Mauricio,

Mauricio> First of all, sorry for the new bug; I didn't realize the
Mauricio> pointer could be NULL at this scenario.

Please do a proper patch submission for this fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
