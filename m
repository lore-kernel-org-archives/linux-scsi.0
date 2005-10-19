From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 0/3] libata: scsi error handling, encore
Date: Wed, 19 Oct 2005 12:47:05 +0900
Message-ID: <4355C1B9.3080700@gmail.com>
References: <43490BC8.9060504@torque.net> <434919E4.1080601@pobox.com> <435069E3.90306@torque.net> <43506AA3.3030502@pobox.com> <43507BA7.6090406@torque.net> <43507D5F.2050407@gmail.com> <435563D0.7050502@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <435563D0.7050502@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, russb@emc.com
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
> 
>> $ cat ~/bin/git-sync.sh
>> #!/bin/sh
>>
>> if [ ! -r .git/origin ]; then
>>         echo "not in git repo" 2>&1
>>         exit 1
>> fi
>>
>> rsync -avz --ignore-existing $(cat .git/origin)/ .git/
>> rsync -avz $(cat .git/origin)/refs/ .git/refs/
>>
>>  After syncing, you need to do 'git-read-tree -m upstream' 
>> 'git-checkout-cache -q -f -u -a'
> 
> 
> 
> In the fast-moving world of git, this is a bit outdated.  You should use
> 
>     git checkout -f upstream
> 
> to check out a specific branch.
> 

  Oh.. there was the '-f' switch.  I always hit 'xxx changed' message 
without the option and have gotten into the habit of using 
read-tree/checkout-cache after a while.  Thanks for the tip.

-- 
tejun
