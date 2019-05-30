From: lijiang <lijiang@redhat.com>
Subject: Re: [PATCH v2] scsi: smartpqi: properly set both the DMA mask and the
 coherent DMA mask in pqi_pci_init()
Date: Thu, 30 May 2019 10:22:17 +0800
Message-ID: <63f06e98-df6f-35dc-da41-dc039f04511d@redhat.com>
References: <20190527005934.1493-1-lijiang@redhat.com>
 <yq14l5czopg.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq14l5czopg.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, don.brace@microsemi.com, jejb@linux.ibm.com, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Thomas.Lendacky@amd.com, dyoung@redhat.com
List-Id: linux-scsi@vger.kernel.org

在 2019年05月30日 10:00, Martin K. Petersen 写道:
> 
> Lianbo,
> 
>> When SME is enabled, the smartpqi driver won't work on the HP DL385
>> G10 machine, which causes the failure of kernel boot because it fails
>> to allocate pqi error buffer. Please refer to the kernel log:
> 
> Applied to 5.2/scsi-fixes, thanks!
> 
OK, thank you, Martin K.

And also thanks to Tom and Don for helping review this patch.

Lianbo
