From: Jerome Martin <jxm@netiant.com>
Subject: Re: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 11:45:45 +0200
Message-ID: <542A7BC9.2050708@netiant.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com> <542A75F1.8070706@gmail.com> <542A77D6.4090109@netiant.com> <542A7ADD.3040804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <542A7ADD.3040804@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Luigi Tarenga <luigi.tarenga@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org



On 09/30/2014 11:41 AM, Luigi Tarenga wrote:
>
> On 09/30/2014 11:28 AM, Jerome Martin wrote:
>> Luigi,
>>
>> Out of curiosity, does it work as expected with the stock fedora
>> packaged kernel ?
>>
>> Best,
>> --
>> Jerome
>>
>
> didn't test that configuration and since I can't find module
> iscsi_target_mod in stock

ok

> kernel I would have to recompile it against centos kernel. It's worth
> trying?

Sure :-)

>
> btw, I saw that after loading the module and manually create the iscsi
> directory this
> content automatically appear:
>
> # ll /sys/kernel/config/target/iscsi/
> total 0
> drwxr-xr-x 2 root root    0 Sep 30 11:38 discovery_auth
> -r--r--r-- 1 root root 4096 Sep 30 11:39 lio_version

Yes, it means that the iscsi module is correctly loaded.

>
> I start suspecting a problem with targetcli or  configshell. I
> regenerated the log.txt file:

Yes, as I said earlier I'll have to reproduce your setup and/or wait for 
Andy to come around.

>
> # targetcli /iscsi info
> No such path /iscsi
>
> # cat log.txt
> [DEBUG] 2014-30-09 11:40:52
> /usr/lib/python2.6/site-packages/configshell/shell.py:932 run_cmdline()
> Running command line '/iscsi info'.
> [DEBUG] 2014-30-09 11:40:52
> /usr/lib/python2.6/site-packages/configshell/shell.py:837
> _parse_cmdline() Parsing commandline.
> [DEBUG] 2014-30-09 11:40:52
> /usr/lib/python2.6/site-packages/configshell/shell.py:844
> _parse_cmdline() [('path', 0, 6, []), ('command', 7, 11, None)]
> [DEBUG] 2014-30-09 11:40:52
> /usr/lib/python2.6/site-packages/configshell/shell.py:848
> _parse_cmdline() Found path token /iscsi.
> [DEBUG] 2014-30-09 11:40:52
> /usr/lib/python2.6/site-packages/configshell/shell.py:848
> _parse_cmdline() Found command token info.
> [DEBUG] 2014-30-09 11:40:52
> /usr/lib/python2.6/site-packages/configshell/shell.py:861
> _parse_cmdline() Parse gave path='/iscsi' command='info' pparams=[]
> kparams={}
> [DEBUG] 2014-30-09 11:40:52
> /usr/lib/python2.6/site-packages/configshell/node.py:1857 get_node()
> Looking for path '/iscsi'
> [DEBUG] 2014-30-09 11:40:52
> /usr/lib/python2.6/site-packages/configshell/node.py:1857 get_node()
> Looking for path 'iscsi'
> [ERROR] 2014-30-09 11:40:52 No such path /iscsi
>
> Luigi
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
