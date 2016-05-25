From: Zhu Lingshan <lszhu@suse.com>
Subject: Re: [PATCHv3 0/2] target: make location of /var/targets configurable
Date: Wed, 25 May 2016 16:01:40 +0800
Message-ID: <57455BE4.9060503@suse.com>
References: <cover.1460678002.git.lduncan@suse.com>
 <572FE52C.2030806@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <572FE52C.2030806@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, hare@suse.de, agrover@redhat.com, jxm@netiant.com
List-Id: linux-scsi@vger.kernel.org

Hi experts,

I think these patches are great, and I am ready to help in user space.

Thanks,
BR
Zhu Lingshan

On 05/09/2016 09:17 AM, Lee Duncan wrote:
> On 04/14/2016 06:18 PM, Lee Duncan wrote:
>> These patches make the location of "/var/target" configurable,
>> though it still defauls to "/var/target".
>>
>> This "target database directory" can only be changed
>> after the target_core_mod loads but before any
>> fabric drivers are loaded, and must be the pathname
>> of an existing directory.
>>
>> This configuration is accomplished via the configfs
>> top-level target attribute "dbroot", i.e. dumping
>> out "/sys/kernel/config/target/dbroot" will normally
>> return "/var/target". Writing to this attribute
>> changes the loation where the kernel looks for the
>> target database.
>>
>> The first patch creates this configurable value for
>> the "dbroot", and the second patch modifies users
>> of this directory to use this new attribute.
>>
>> Changes from v2:
>>   * Add locking around access to target driver list
>>
>> Changes from v1:
>>   * Only allow changing target DB root before it
>>     can be used by others
>>   * Validate that new DB root is a valid directory
>>
>> Lee Duncan (2):
>>    target: make target db location configurable
>>    target: use new "dbroot" target attribute
>>
>>   drivers/target/target_core_alua.c     |  6 ++--
>>   drivers/target/target_core_configfs.c | 62 +++++++++++++++++++++++++++++++++++
>>   drivers/target/target_core_internal.h |  6 ++++
>>   drivers/target/target_core_pr.c       |  2 +-
>>   4 files changed, 72 insertions(+), 4 deletions(-)
>>
> Ping?
