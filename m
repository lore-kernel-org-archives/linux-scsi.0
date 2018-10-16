From: cang@codeaurora.org
Subject: Re: [PATCH v5 1/1] scsi: ufs: make UFS Tx lane1 clock optional for
 QCOM platforms
Date: Tue, 16 Oct 2018 12:05:00 +0800
Message-ID: <98938b7462e2a90e1b2089d6c6706c52@codeaurora.org>
References: <1539397502-30120-1-git-send-email-cang@codeaurora.org>
 <yq1ftx6wqeh.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ftx6wqeh.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dianders@chromium.org, subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, evgreen@chromium.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

On 2018-10-16 10:56, Martin K. Petersen wrote:
> Can,
> 
>> Per Qcom's UFS host controller HW design, the UFS Tx lane1 clock could
>> be muxed with Tx lane0 clock, hence keep Tx lane1 clock optional by
>> ignoring it if it is not provided in device tree. This change also
>> performs some cleanup to lanes per direction checks when
>> enable/disable lane clocks just for symmetry.
> 
> Applied to 4.20/scsi-queue, thanks!

Thanks a lot!

-Can Guo
