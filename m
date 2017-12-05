From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: Re: UFS utilities
Date: Tue, 5 Dec 2017 15:44:19 +0000
Message-ID: <95e2fba3abb6447ba741b6235dd2e375@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi, greg k-h

>
>So what UFS commands are you missing that you need to see implemented?
>
>And again, have you checked the different forks of the driver?
>

Seems there is something misunderstood, I want to use UPIU, rather than CDB.
Maybe it is not possible based on current UFS stacks. Of course, exactly, 
there is no missing SCSI command listed in UFS 2.1.

>> >> And also it doesn't support several UFS special command.
>> >
>> >Are you referring to SCSI commands or rather to UFS commands that
>> >fall outside the SCSI spec? Anyway, an approach that is used by many
>> >SCSI drivers to export information to user space that falls outside
>> >the SCSI spec is to create additional sysfs attributes. See also the
>> >sdev_attrs and shost_attrs members of struct scsi_host_template.
>> >
>> Yes, for the UFS information, I can use these interface/approach to easily
>get.
>> I am thinking how about some testing case and configuration operation.
>
>Which ones exactly?
>
>> Also, is it possible bypass SCSI stacks and go into directly UFS stack?
>
>Look at the different sysfs files for the UFS device, it does that for some
>commands.
>
To be honest, I don't know which interface, it can pass UPIU to UFS driver,
And bypass SCSI stacks.

Thanks.
Bean Huo
