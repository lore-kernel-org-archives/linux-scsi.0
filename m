From: Luigi Tarenga <luigi.tarenga@gmail.com>
Subject: Re: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 11:20:49 +0200
Message-ID: <542A75F1.8070706@gmail.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <542A73BE.2080501@netiant.com>
Sender: target-devel-owner@vger.kernel.org
To: Jerome Martin <jxm@netiant.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org


>> I have installed targetcli from centos rpm:
>> # rpm -qi fcoe-target-utils-2.0rc1.fb16-5.el6.noarch
>
> See the version here? ....fb16...
>
oh ok.
>> I'm not sure what is the initscript you mention. I have in /etc/init.d/:
>> # ls fcoe-target iscsi*
>> fcoe-target  iscsi  iscsid
>>
>> but afaik those are for the initiatior or fcoe-target...
>
> Well, given the name of the redhat package, my best best would be 
> fcoe-target :-)
>

I started it but still no luck, actually I had to comment out 2 module 
loading since I didn't
compiled them (can this be the problem? would be strange since there is 
no module
dependencies...):

load_modules()
{
     errmsg=$( /sbin/modprobe configfs 2>&1 ) || return 1
     errmsg=$( /sbin/modprobe target_core_mod 2>&1 ) || return 1
     #errmsg=$( /sbin/modprobe target_core_pscsi 2>&1 ) || return 1
     errmsg=$( /sbin/modprobe target_core_file 2>&1 ) || return 1
     #errmsg=$( /sbin/modprobe target_core_iblock 2>&1 ) || return 1

     return 0
}



Luigi
