From: Zefan Li <lizefan@huawei.com>
Subject: Re: Backport of a fix for HPSA (Disabling a disabled device problem
 during kdump) driver
Date: Mon, 15 Jun 2015 11:33:32 +0800
Message-ID: <557E478C.7070205@huawei.com>
References: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com> <54AC0A17.8020405@redhat.com> <20150128001837.GE17677@kroah.com> <CAHTgTXU1GV8JszqJojk9ML7f1yEtERHY0VjrnjX+OMh4Z_=t0g@mail.gmail.com> <552BC234.4020000@redhat.com> <20150426092719.GA1460@kroah.com> <553E28DC.1040100@redhat.com> <20150427125529.GA18817@kroah.com> <553E354B.90208@redhat.com> <20150502175621.GA15525@kroah.com> <CAHTgTXX9tm-tdUPzWXd9SJB_MUanMrNe1x9hD9DzU9R5cmuNnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAHTgTXX9tm-tdUPzWXd9SJB_MUanMrNe1x9hD9DzU9R5cmuNnQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Vinson Lee <vlee@twopensource.com>
Cc: Greg KH <greg@kroah.com>, Tomas Henzl <thenzl@redhat.com>, Masoud Sharbiani <msharbiani@twopensource.com>, stable@vger.kernel.org, Don Brace <Don.Brace@pmcs.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> The first and second patches are from upstream 3.18. The third patch
> is from upstream 4.0.
> 
> Please use the following list of kernels and patches for backporting.
> 
> 3.18, 3.19
> 3b74729878 hpsa: turn off interrupts when kdump starts
> 
> <= 3.17
> 132aa220b4 hpsa: refine the pci enable/disable handling
> 859c75aba2 hpsa: add missing pci_set_master in kdump path
> 3b74729878 hpsa: turn off interrupts when kdump starts
> 

I've queued up the above 3 commits for 3.4, and this one:

03741d956e hpsa: fix memory leak in kdump hard reset
