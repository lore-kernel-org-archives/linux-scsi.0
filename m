From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 10/15] megaraid_sas: Return pended IOCTLs with
 cmd_status MFI_STAT_WRONG_STATE in case adapter is dead
Date: Tue, 11 Jul 2017 15:42:37 +0200
Message-ID: <892809f1-e284-b0f0-8334-af84f86d2c34@redhat.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1499256029-16319-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-MW
Sender: stable-owner@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5.7.2017 14:00, Shivasharan S wrote:
> Fix - After a kill adapter, since the cmd_status is not set the
> IOCTLs will be hung in driver resulting in application hang.
> Set cmd_status MFI_STAT_WRONG_STATE when completing pended IOCTLs.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

tomash
