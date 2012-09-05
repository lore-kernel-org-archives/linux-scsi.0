From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [V2 PATCH 1/9] csiostor: Chelsio FCoE offload driver submission
 (sources part 1).
Date: Wed, 5 Sep 2012 22:48:24 +0530
Message-ID: <50478960.5000003@chelsio.com>
References: <1346848442-4573-1-git-send-email-naresh@chelsio.com> <1346848442-4573-2-git-send-email-naresh@chelsio.com> <20120905092326.0a54226f@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20120905092326.0a54226f@nehalam.linuxnetplumber.net>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dimitrios Michailidis <dm@chelsio.com>, Casey Leedom <leedom@chelsio.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Chethan Seshadri <chethan@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On 9/5/2012 9:53 PM, Stephen Hemminger wrote:
> On Wed,  5 Sep 2012 18:03:54 +0530
> Naresh Kumar Inna <naresh@chelsio.com> wrote:
> 
>> +
>> +/* FCoE Adapter types & its description */
>> +static struct csio_adap_desc csio_fcoe_adapters[] = {
> 
> Tables like this should be const.
> 

Thanks for reviewing. I will change it to const.
