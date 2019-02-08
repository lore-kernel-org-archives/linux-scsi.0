From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5] scsi/ata: Use unsigned int for cmd's type in ioctls in scsi_host_template
Date: Fri, 08 Feb 2019 17:33:22 -0500
Message-ID: <yq1pns1x64t.fsf@oracle.com>
References: <20190126075256.29608-1-natechancellor@gmail.com>
        <20190207160719.28895-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190207160719.28895-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Thu, 7 Feb 2019 09:07:20 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, Brian King <brking@us.ibm.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Marc Gonzalez <marc.w.gonzalez@free.fr>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Bradley Grove <bgrove@attotech.com>, Don Brace <don.brace@microsemi.com>, Bart Van Assche <bvanassche@acm.org>, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Clang warns several times in the scsi subsystem (trimmed for brevity):

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
