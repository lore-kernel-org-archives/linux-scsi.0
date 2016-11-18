From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Thu, 17 Nov 2016 20:51:22 -0500
Message-ID: <yq1inrl7dyd.fsf@sermon.lab.mkp.net>
References: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
        <be84afd4-640d-1913-404a-505fd72c1324@huawei.com>
        <b800ae5c-f275-728c-27b4-230663757781@huawei.com>
        <CAPcyv4g+XzCuHsUvqeE+r8hqgPK3yq=E9k23a89XcLs96bkphg@mail.gmail.com>
        <CAPcyv4hvuFLhS2sYXkccXMTSh-ggxo7uHN2Qt6i5g8GkyBksrw@mail.gmail.com>
        <9870e7bc-a472-1913-1930-ac022e8ad5e8@huawei.com>
        <58257D52.6090507@huawei.com>
        <93ae84f6-75a2-f576-808e-f98c6256b6a6@huawei.com>
        <58258631.1090203@huawei.com>
        <9bdd2ca5-aa72-6a18-b66d-8e791e4852c7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9bdd2ca5-aa72-6a18-b66d-8e791e4852c7@huawei.com> (John Garry's
        message of "Thu, 17 Nov 2016 15:23:32 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, wangyijing <wangyijing@huawei.com>, Dan Williams <dan.j.williams@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, john.garry2@mail.dcu.ie, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxarm@huawei.com, lindar_liu@usish.com, Tejun Heo <tj@kernel.org>, jinpu.wang@profitbricks.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> @Maintainers, would you be willing to accept this patch as an
John> interim fix for the dastardly WARN while we try to fix the flutter
John> issue?

I'll defer to James since I don't have much libsas experience.

-- 
Martin K. Petersen	Oracle Linux Engineering
